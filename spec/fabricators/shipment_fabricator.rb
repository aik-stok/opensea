Fabricator(:shipment) do
  title { Faker::Lorem.word }
  hold_capacity { 10_000 }
end
