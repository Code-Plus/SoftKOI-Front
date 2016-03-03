class Product < ActiveRecord::Base


  include AASM
  belongs_to :category
  has_many :output_products
  has_many :input_products

  validates :name, :description, :price, :stock_min, :state, :category_id, presence: true
  validates :stock, numericality: {greater_than_or_equal_to: 0}

  #El scope verifica y nos trae los productos que tengan estado disponible
  scope :activos, -> { where(state: "disponible")}

  #Productos activos cuya cantidad sea mayor a cero.
  scope :activos_y_cantidad, ->{ activos.where("stock >= stock_min")}

  #Productos que esten activos y tengan cantidad en su stock
  scope :activos_con_cantidad, ->{activos.where("stock > 0")}

  aasm column: "state" do

    state :disponible, :initial => true
    state :noDisponible
    state :deBaja

    event :disponible do
      transitions from: :noDisponible, to: :diponible
    end
    event :noDisponible do
      transitions from: :disponible, to: :noDisponible
    end

    event :deBaja do
      transitions from: :disponible, to: :deBaja
    end
  end

end
