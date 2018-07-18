Puppet::Type.newtype(:mongodb_user) do
  @doc = 'Manage a MongoDB user. This includes management of users password as well as privileges.'

  ensurable

  def initialize(*args)
    super
    # Sort roles array before comparison.
#    #GRRR.  Can't quite get this to work...  For now, puppet will try to re-apply some things because it can't tell they're already there :(
#    self[:roles].sort! { |x,y|
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

  newparam(:name, :namevar=>true) do
    desc "The name of the user."
  end

  newparam(:database) do
    desc "The user's target database."
    defaultto do
      fail("Parameter 'database' must be set")
    end
    newvalues(/^\w+$/)
  end

  newparam(:tries) do
    desc "The maximum amount of two second tries to wait MongoDB startup."
    defaultto 10
    newvalues(/^\d+$/)
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:roles, :array_matching => :all) do
    desc "The user's roles."
    # Pretty output for arrays.
    def should_to_s(value)
      value.inspect
    end
    def is_to_s(value)
      value.inspect
    end
  end

  newproperty(:password_hash) do
    desc "The password hash of the user. Use mongodb_password() for creating hash."
    defaultto do
      fail("Property 'password_hash' must be set. Use mongodb_password() for creating hash.")
    end
    newvalue(/^\w+$/)
  end

  autorequire(:package) do
    'mongodb'
  end

  autorequire(:service) do
    'mongodb'
  end
end
