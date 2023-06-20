(1..20).to_a.each do |i|
  User.create(name: "Admin #{i}", email: "admin#{i}@example.com", role: 'admin', password: 123456)
end

(1..20).to_a.each do |i|
  School.create(name: "School #{i}")
end

(1..30).to_a.each do |i|
  User.create(name: "School Admin #{i}", email: "schooladmin#{i}@example.com", role: 'school_admin', password: 123456)
end

(1..100).to_a.each do |i|
  User.create(name: "Student #{i}", email: "student#{i}@example.com", role: 'student', password: 123456)
end