print("==========================================")
print("🔍 MEMULAI SCANNER REMOTE EVENT (CHOP YOUR TREE)")
print("==========================================")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteCount = 0

-- Menggeledah semua folder dan isi di dalam ReplicatedStorage
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        remoteCount = remoteCount + 1
        -- Mencetak nama dan lokasi persis RemoteEvent-nya
        print("💡 [" .. remoteCount .. "] Nama: " .. obj.Name .. " | Lokasi: " .. obj:GetFullName())
    end
end

print("==========================================")
print("✅ SCAN SELESAI! Total ditemukan: " .. remoteCount .. " RemoteEvents.")
print("==========================================")
