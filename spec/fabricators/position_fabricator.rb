Fabricator(:position) do
  port { Port.order("RANDOM()").first }
  opened_at { Date.today }
end
