# # db/seeds.rb

# # Suppression des utilisateurs et des entreprises existants
User.delete_all
Compagny.delete_all


compagny = Compagny.create!(
  name: "Ma Super Compagnie",
  description: "Description de la compagnie"
)


# Création d'une entreprise (Compagny)
compagny = Compagny.create!(
  name: "Inasen",
  address: "123 Rue Exemple",
  city: "Dakar",
  state: "Dakar",
  countrie: "Sénégal",
  zipCode: "10000",
  phoneNumber: "1234567890",
  email: "contact@inasen.sn",
  website: "http://www.inasen.sn",
  description: "Entreprise de bouillons de qualité",
  url: "http://www.inasen.sn"
)

# Création de quelques utilisateurs pour le login et l'enregistrement
user1 = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  compagny_id: compagny.id,  # Association avec l'entreprise créée
  role: 'admin'  # Par exemple, ajouter un rôle d'administrateur
)

user2 = User.create!(
  email: 'user@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  compagny_id: compagny.id   # Association avec l'entreprise créée
)

user3 = User.create!(
  email: 'guest@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  compagny_id: compagny.id   # Association avec l'entreprise créée
)


shop = Shop.create!(
  name: "Boutique Centrale",
  user: user3
)
# puts "3 utilisateurs créés avec une entreprise !"
# Seed de catégories
categories = [
  { name: "Habillement", shop_id: 1 },
  { name: "Bureautique", shop_id: 1 },
  { name: "Beauté", shop_id: 1 }
]

categories.each do |category|
  Category.create!(category)
end

# Seed de produits
20.times do |i|
  Product.create!(
    name: "Produit ##{i + 1}",
    description: "Description du produit ##{i + 1}",
    price: (rand(10..100) + rand).round(2),  # Prix aléatoire entre 10 et 100
    stock: rand(5..50),  # Stock aléatoire entre 5 et 50
    shop_id: 1,  # Assignation à shop_id = 1
    category_id: rand(1..3),  # Catégories aléatoires entre 1 et 3
    created_at: Time.now,
    updated_at: Time.now
  )
end

puts "20 produits ont été créés."