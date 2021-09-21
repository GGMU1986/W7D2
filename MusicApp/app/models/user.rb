# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord

    after_initialize :ensure_session_token

    validates :email, :session_token, presence: true, uniquness: true
    validates :password_digest, presence: true

    def self.generate_session_token
        self.session_token = SecureRandom::urlsafe_base64
    end

    def reset_session_token!
        User.generate_session_token
        self.save!
        self.session_token
    end

    def self.ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64 
    end

    def password=(password)
        self.password_digest = Bcrypt::Password.create(password)
        @password = password
    end

    def password
        @password
    end

    def is_password?(password)
        password_object = Bcrypt::Password.new(self.password_digest)
        password_object.is_password?(password)
    end

    def self.find_by_credentials(email, password)
        user = User.find_by(emial: params[:email])
        
        if user && user.is_password?(password)
            user
        else
            flash[:errors] = 'Invalid Email and/or Password'
            redirect_to new_user_url
        end
    end
end
