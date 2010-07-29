class Pfeeds::UserTriggeredArticle < PfeedItem
   validates_presence_of :participant, :originator
  
   def pack_data(method_name,method_name_in_past_tense,returned_result,*args_supplied_to_method,&block_supplied_to_method) 
     super
   end
 end  
