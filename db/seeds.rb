# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.new(email: "sokly@instedd.org")
u.password = "123456"
u.save
u.confirm

# Seed predefined facilities
predefined_facilities = [
  { code: "PA", name_en: "Public Administration", name_km: "រដ្ឋបាលសាធារណៈ", parent_code: nil, category_code: nil },
  { code: "CA", name_en: "Commune Administrative", name_km: "រដ្ឋបាលឃុំសង្កាត់", parent_code: "PA", category_code: nil },
  { code: "ED", name_en: "Education", name_km: "ការអប់រំ", parent_code: nil, category_code: nil },
  { code: "PS", name_en: "Primary School", name_km: "បឋមសិក្សា", parent_code: "ED", category_code: "DS_PS" },
  { code: "HE", name_en: "Health", name_km: "សុខភាព", parent_code: nil, category_code: nil },
  { code: "HC", name_en: "Health Center", name_km: "មណ្ឌលសុខភាព", parent_code: "HE", category_code: nil },
  { code: "GS", name_en: "Garment Sector", name_km: "វិស័យកាត់ដេរ", parent_code: nil, category_code: nil },
  { code: "FA", name_en: "Factory", name_km: "រោងចក្រ", parent_code: "GS", category_code: "D_FA" }
]

predefined_facilities.each do |attrs|
  PredefinedFacility.find_or_create_by!(code: attrs[:code]) do |pf|
    pf.name_en = attrs[:name_en]
    pf.name_km = attrs[:name_km]
    pf.parent_code = attrs[:parent_code]
    pf.category_code = attrs[:category_code]
  end
end
