class User < ActiveRecord::Base

	has_many :sales
	belongs_to :role
	belongs_to :type_document
	has_many :calendar

	validates :document, presence: true, uniqueness: true

	# validates :firstname,  presence: true
	# validates :lastname,  presence: true
	# validates :email, presence: true, uniqueness: true
	# validates :phone,  numericality: {greater_than: 0}
	# validates :cellphone, numericality: {greater_than: 0}
	# validates :role_id,  presence: true
	# validates :state,  presence: true
	# validates :type_document_id,  presence: true
	before_create :validate_pass

	before_create :set_date
	before_update :set_updated_at


	devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:document]


	include AASM

	aasm column: "state" do

		state :disponible, :initial => true
		state :noDisponible


		event :disponible do
			transitions from: :noDisponible, to: :disponible
		end

		event :noDisponible do
			transitions from: :disponible, to: :noDisponible
		end
	end


	def email_required?
		false
	end

	def email_changed?
		false
	end

	def name
		"#{firstname} #{lastname}"
	end

	private

	def validate_pass
		validates_presence_of :password
	end

	def set_date
		self.created_at = Time.now.in_time_zone("Bogota")
		self.updated_at = Time.now.in_time_zone("Bogota")
	end

	def set_updated_at
		self.updated_at = Time.now.in_time_zone("Bogota")
	end
end
