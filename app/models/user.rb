class User < ActiveRecord::Base
    has_many :medications
    has_secure_password
end