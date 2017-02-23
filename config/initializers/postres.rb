# ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.tap do |klass|
#   klass::OID.register_type('hstore', klass::OID::Identity.new)
# end