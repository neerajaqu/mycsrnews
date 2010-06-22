Pfeed -- Resque Support
=======================

Now including support for Resque asynchronous processing


### How do we make it happen?
We only need two changes to enable Resque support with Pfeeds.

*1) Create a Resque worker*

A simple example is to create a notification worker as follows:

<pre>
<code>
	class NotificationWorker
	  @queue = :notifications

	  # Takes a PfeedItem and stringified PfeedItem.attemp_delivery method params
	  def self.perform(pfeed_item_id, ar_obj_klass_name, ar_obj_id, method_name_arr)
		pfeed_item = PfeedItem.find(pfeed_item_id)
		klass = ar_obj_klass_name.constantize
		ar_obj = klass.find(ar_obj_id)
		pfeed_item.deliver(ar_obj, method_name_arr)
	  end

	end
</code>
</pre>

We cannot use object references with Resque, so we must take params to identify the class and id of the ActiveRecord object we will be using as the source of the delivery targets. After re-instanting the ActiveRecord object we simply call the PfeedItem delivery method as normal. Now we just need to identify our target Resque worker so Pfeed knows what worker to use when enqueuing the job to Resque.

*2) Define the PFEED_RESQUE_KLASS in your Resque initializer to be the desired worker.*

Continuing with our example, to use the NotificationWorker, we would add this line to the Resque initializer:

<pre>
<code>
	PFEED_RESQUE_KLASS = NotificationWorker
</code>
</pre>

Notice we are passing a reference to our worker class, and not the string name of the worker class. After restarting your app and the resque workers, you should have Pfeed delivery performed asynchronously by Resque. Enjoy!
