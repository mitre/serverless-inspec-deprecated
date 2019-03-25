require 'json'
require 'inspec'

def inspec_scan(event:, context:)
    { event: JSON.generate(event), context: JSON.generate(context.inspect) }

    # Set Runner Options
    opts = {
      "backend" => "aws"
    }

    # Define InSpec Runner
    client = Inspec::Runner.new(opts)

    # Set InSpec Target
    client.add_target(ENV['INSPEC_PROFILE'],opts)

    # Trigger InSpec Scan
    client.run
end
