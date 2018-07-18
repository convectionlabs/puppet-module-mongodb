Puppet::Type.type(:mongodb_user).provide(:mongodb) do

  desc "Manage users for a MongoDB database."

  defaultfor :kernel => 'Linux'

  commands :mongo => 'mongo'

  def block_until_mongodb(tries = 10)
    begin
      mongo('--quiet', '--eval', 'db.getMongo()')
    rescue
      debug('MongoDB server not ready, retrying')
      sleep 2
      retry unless (tries -= 1) <= 0
    end
  end

  def create
    cmd_json=<<-EOS.gsub(/^\s*/, '').gsub(/$\n/, '')
    {
      "createUser": "#{@resource[:name]}",
      "pwd": "#{@resource[:password_hash]}",
      "roles": #{@resource[:roles].to_json},
      "digestPassword": false
    }
    EOS

    mongo("#{@resource[:database]}", '--quiet', '--eval', "db.runCommand(#{cmd_json})")
  end

  def destroy
    mongo("#{@resource[:database]}", '--quiet', '--eval', "db.dropUser('#{@resource[:name]}')")
  end

  def exists?
    block_until_mongodb(@resource[:tries])
    mongo('admin', '--quiet', '--eval', "db.system.users.find({user: '#{@resource[:name]}', db: '#{@resource[:database]}'}).count()").strip.eql?('1')
  end

  def password_hash
    users = JSON.parse(mongo('admin', '--quiet', '--eval', "printjson(db.system.users.find({user: '#{@resource[:name]}', db: '#{@resource[:database]}'}).toArray())"))
    if users.length and users[0]['credentials'].has_key?('MONGODB-CR')
      return users[0]['credentials']['MONGODB-CR'].gsub(/"/,'').strip
    else
      return nil
    end
  end

  def password_hash=(value)
    cmd_json=<<-EOS.gsub(/^\s*/, '').gsub(/$\n/, '')
      {
        "updateUser": "#{@resource[:name]}",
        "pwd": "#{@resource[:password_hash]}",
        "digestPassword": false
      }
    EOS

    mongo("#{@resource[:database]}", '--quiet', '--eval', "db.runCommand(#{cmd_json})")
  end

  def roles
    JSON.parse(mongo("#{@resource[:database]}", '--quiet', '--eval', "printjson(db.getUser('#{@resource[:name]}')['roles'])"))
# .sort { |x,y|
#      if x.class == Hash and y.class == Hash
#        if x[:db] == y[:db]
#          x[:role] <=> y[:role]
#        else
#          x[:db] <=> y[:db]
#        end
#      elsif x and y
#        x <=> y
#      else
#        -1
#      end
#    }
  end

  def roles=(value)
    grant = @resource[:roles] - roles
    if grant.length > 0
      mongo("#{@resource[:database]}", '--quiet', '--eval', "db.grantRolesToUser('#{@resource[:name]}', #{grant.to_json})")
    end

    revoke = roles - @resource[:roles]
    if revoke.length > 0
      mongo("#{@resource[:database]}", '--quiet', '--eval', "db.revokeRolesFromUser('#{@resource[:name]}', #{revoke.to_json})")
    end
  end

end
