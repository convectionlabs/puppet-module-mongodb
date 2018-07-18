# Fact to expose if instance is primary or not.
# Returns true if primary
Facter.add(:mongodb_isprimary) do
  setcode do
    Facter::Util::Resolution.exec("mongo --quiet --eval 'db.isMaster().ismaster' 2>/dev/null | grep -x true || echo false")
  end
end

# Fact to expose our mongodb version
Facter.add(:mongodb_version) do
  setcode do
    if Facter::Core::Execution.which('mongo')
      mongodb_version = Facter::Core::Execution.execute('mongo --version 2>&1')
      %r{^MongoDB shell version: ([\w\.]+)}.match(mongodb_version)[1]
    end
  end
end

# Fact to determine our replica set based on sequence ID
seq_id = `hostname`.split('.').first.split('-').last

# If we're a dyn seq instance, set mongodb_replset fact to rs666 (HAIL SATAN)
if seq_id.length == 8 || seq_id.length == 17
  Facter.add(:mongodb_replset) do
    setcode do
      'rs666'
    end
  end

# If our hostname seq ID is two digits, split and set fact based on first number
elsif seq_id.length == 2 && seq_id =~ /[0-9]{2}/
  Facter.add(:mongodb_replset) do
    setcode do
      # this prolly isn't safe for rubby versions higher than 1.8.x
      "rs#{seq_id[0,1]}"
    end
  end

# If our last segment starts with 'r', then we use a slightly different hostname format
elsif seq_id.start_with? 'r'
  Facter.add(:mongodb_replset) do
    setcode do
      "rs#{/^r([0-9]+)[^0-9]/.match(seq_id)[1]}"
    end
  end  
end

