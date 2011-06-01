# This is an example custom module.
class What::Modules::CustomModule < What::Modules::Base
  # You can provide defaults for any settings you're expecting the config file
  # to provide.
  # (optional)
  DEFAULTS = {
    'hello' => 'hello',
    'world' => 'world'
  }

  # You can use the initialize_module method to set up any data structures
  # you'll be using.
  # (optional)
  def initialize_module
    @hellos = 1
  end

  # The check! method is called every Config['interval'] seconds. It should
  # collect whatever information is needed and put it into instance vars.
  # (optional)
  def check!
    @hellos = Kernel.rand(4) + 1
  end

  # The health and details methods are called whenever the server receives
  # an HTTP request.

  # health should return one of the following strings:
  #   'ok'        Everything's fine.
  #   'warning'   There's a problem, but it's not critical.
  #   'alert'     I need to get out of bed to fix this.
  # (mandatory)
  def health
    'ok'
  end

  # details can return a hash containing any additional information
  # that might be interesting to the consumer of the status updates.
  # (optional)
  def details
    greeting = []
    @hellos.times do
      greeting << @config['hello']
    end
    @hellos.times do
      greeting << @config['world']
    end
    {'greeting' => greeting.join(' ') + '!'}
  end
end
