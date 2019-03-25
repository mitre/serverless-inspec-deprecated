require 'json'
require 'inspec'

def handler(event:, context:)
    { event: JSON.generate(event), context: JSON.generate(context.inspect) }

  opts = {
    "backend" => "ssh",
    "host" => event["host"],
    "port" => event["port"],
    "user" => event["username"],
    "password" => event["password"]
  }

  client = Inspec::Runner.new(opts)

  client.add_target("https://github.com/martezr/serverless-inspec-profile", opts)

  client.run
end
