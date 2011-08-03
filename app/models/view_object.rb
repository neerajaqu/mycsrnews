class ViewObject < ActiveRecord::Base
  
  belongs_to :view_object_template
  belongs_to :parent, :class_name => "ViewObject", :foreign_key => :parent_id
  #has_one :setting, :class_name => "Metadata::ViewObjectSetting", :as => :metadatable
  has_one :setting, :class_name => "Metadata", :as => :metadatable

  has_many :direct_view_tree_edges, :class_name => "ViewTreeEdge", :foreign_key => :parent_id, :order => "position desc"
  has_many :indirect_view_tree_edges, :class_name => "ViewTreeEdge", :foreign_key => :child_id, :order => "position desc"
  has_many :edge_children, :through => :direct_view_tree_edges, :source => :child, :order => "position desc"
  has_many :edge_parents, :through => :indirect_view_tree_edges, :source => :parent, :order => "position desc"

  def dataset
    return @dataset if defined?(@dataset)
    if setting and setting.is_a?(Metadata::ViewObjectSetting)
      @dataset = setting.dataset ? setting.load_dataset : setting.kommand_chain
    end
    @dataset ||= []
  end

  def children
    self.class.find(:all, :conditions => ["parent_id = ?", self.id])
  end

  def self.load key_name
    self.find_by_name(key_name)
  end

  def view_tree
    @view_tree ||= ViewTree.new name, nil, self
  end

  def add_parent! parent_view_object, position = 0
    ViewTreeEdge.create!({:parent => parent_view_object, :child => self, :position => position})
  end

  def add_child! child_view_object, position = 0
    ViewTreeEdge.create!({:child => child_view_object, :parent => self, :position => position})
  end

  def add_dataset_dep klass
    $redis.sadd dataset_key, klass.cache_id
    $redis.sadd klass.model_deps_key, self.cache_id
  end

  def add_dataset_deps
    dataset.map {|k| add_dataset_dep(k) }
  end

  def rem_dataset_dep klass
    $redis.srem dataset_key, klass.cache_id
    $redis.srem klass.model_deps_key, self.cache_id
  end

  def rem_dataset_deps
    dataset.each {|k| rem_dataset_dep(k) }
  end

  def r_dataset
    {
      :dataset_keys => $redis.smembers(dataset_key),
      :klass_dep_keys => dataset.inject({}) {|s,k| s["#{k.cache_id}"] = $redis.smembers(k.model_deps_key); s},
      :namespaces_key => $redis.smembers(namespaces_key),
      :namespace_deps => setting.kommands.inject({}) {|s,k| s[namespace_deps_key(setting.klass_name, k[:method_name])] = $redis.smembers(namespace_deps_key(setting.klass_name, k[:method_name])); s}
    }
  end

  def add_namespace_deps
    return false unless setting and setting.is_a?(Metadata::ViewObjectSetting)

    if setting.kommands.any? and setting.klass_name.present?
      setting.kommands.each do |kommand|
        if kommand[:method_name].present?
          $redis.sadd namespaces_key, klass_method_key(setting.klass_name, kommand[:method_name])
          $redis.sadd namespace_deps_key(setting.klass_name, kommand[:method_name]), self.cache_id
        end
      end
    end
  end

  def rem_namespace_deps
    return false unless setting and setting.is_a?(Metadata::ViewObjectSetting)

    if setting.kommands.any? and setting.klass_name.present?
      setting.kommands.each do |kommand|
        if kommand[:method_name].present?
          $redis.srem namespaces_key, klass_method_key(setting.klass_name, kommand[:method_name])
          $redis.srem namespace_deps_key(setting.klass_name, kommand[:method_name]), self.cache_id
        end
      end
    end
  end

  def cache_deps
    add_dataset_deps
    add_namespace_deps
  end

  def uncache_deps
    rem_dataset_deps
    rem_namespace_deps
    $redis.del view_tree_cache_key_name
    edge_parents.each {|p| p.uncache_deps }
  end

  def expire
    view_tree.uncache_it
    edge_parents.map(&:expire)
    uncache_deps
  end

  def self.uncache_all
    ViewObject.all.each {|vo| vo.uncache_deps}
  end

  def cache_key_name
    name.parameterize.to_s
  end

  def view_tree_cache_key_name
    "view-tree:#{cache_key_name}"
  end

  private
    
    def klass_method_key klass_name, method
      "#{klass_name.downcase}:#{method.to_s.downcase}"
    end

    def dataset_key
      "#{self.cache_id}:dataset"
    end

    def namespaces_key
      "#{self.cache_id}:namespaces"
    end

    def namespace_deps_key klass_name, namespace
      "#{klass_name.downcase}:view_object_namespace_deps:#{namespace}"
    end

end
