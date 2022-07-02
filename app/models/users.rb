class User < ApplicationRecord
    validates :eth_address, presence: true, uniqueness: true
    validates :eth_nonce, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
end
#uniquenessは属性の値が一意（unique）であり重複していないことを確認している