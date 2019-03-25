require 'json'
require 'inspec'

def inspec_scan(event:, context:)
    { event: JSON.generate(event), context: JSON.generate(context.inspect) }

    opts = {
      "backend" => "aws"
    }

    client = Inspec::Runner.new(opts)

    client.add_target("https://github.com/martezr/serverless-inspec-profile",opts)

    client.run
end
