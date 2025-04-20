# db/seeds.rb

# Suppression des données existantes (optionnel, pour repartir à zéro)
User.destroy_all
Shop.destroy_all
Product.destroy_all

# Création d'un utilisateur
user = User.create!(
  email: "admin@example.com",
  password: "password123",
  name: "Admin User"
)

puts "Utilisateur créé : #{user.email}"

# Création d'un shop lié à cet utilisateur
shop = Shop.create!(
  name: "Boutique Centrale",
  user: user
)

puts "Shop créé : #{shop.name} pour l'utilisateur #{shop.user.email}"

# Création de quelques produits liés au shop
products = [
  { name: "Produit 1", price: 100 },
  { name: "Produit 2", price: 200 },
  { name: "Produit 3", price: 300 }
]

products.each do |prod_attrs|
  product = Product.create!(prod_attrs.merge(shop: shop))
  puts "Produit créé : #{product.name} dans le shop #{shop.name}"
end

# Tu peux ajouter d'autres seeds ici selon tes autres modèles et relations

puts "Seed terminé avec succès !"
