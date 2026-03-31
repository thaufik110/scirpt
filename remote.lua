local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Hanya menyadap perintah "FireServer" (Data dari Client ke Server)
    if not checkcaller() and method == "FireServer" then
        print("=============================")
        print("🎯 REMOTE KETANGKAP: " .. tostring(self.Name))
        
        -- Menampilkan isi data yang dikirim
        for i, v in ipairs(args) do
            print("   ▶ Argumen " .. i .. ": " .. tostring(v))
        end
        print("=============================")
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
print("✅ Console Spy Berhasil Aktif! Buka F9 dan lakukan sesuatu di game.")
