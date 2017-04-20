ports = JSON.parse File.read('app/lib/data/ports.txt')
Port.create ports