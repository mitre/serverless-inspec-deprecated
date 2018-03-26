require 'inspec'

r = Inspec::Runner.new()
r.add_target('/inspec/inspec/examples/profile-sensitive')
output = r.run
print output
