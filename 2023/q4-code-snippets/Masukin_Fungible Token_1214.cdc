impor NonFungibleToken dari  0xa340dc0a4ec828ab
impor Avataaar dari  0xf8d6e0586b0a20c7

// Orang yang mentransfer NFT adalah orang yang menandatangani ini
transaksi ( nftIDs : [UInt64], penerima : [Alamat]) {

    // Referensi ke koleksi penarikan
    biarkan  penarikanRef : & Avataaars . Koleksi

    persiapkan ( penanda tangan : AuthAccount) {
        // pinjam referensi ke koleksi NFT penandatangan
        self .withdrawRef = penandatangan.pinjam < &Avataaars.Collection > ( dari : Avataaars.CollectionStoragePath)
                ??  panik ( “ Akun tidak menyimpan objek pada jalur yang ditentukan ” )
    }

    mengeksekusi {
        untuk saya, nftID di nftIDs {
            // dapatkan alamat penerima untuk nftID ini
            biarkan  penerima : Alamat = penerima[i]

            // Referensi koleksi tempat menyimpan NFT
            biarkan  depositRef = getAccount (penerima). getCapability (Avataaars.CollectionPublicPath)
                                .pinjam < &Avataaars.Collection{NonFungibleToken.CollectionPublic} > ()
                                ??  panik ( “ Tidak dapat meminjam referensi koleksi penerima ” )

            // menarik NFT dari koleksi pemiliknya
            biarkan  nft <- self .withdrawRef. menarik ( penarikanID : nftID)

            // Setorkan NFT ke koleksi penerima
            depositRef. setoran ( tanda : <- nft)
        }
    }
}
