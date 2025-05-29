-- CreateTable
CREATE TABLE "resepi" (
    "id" SERIAL NOT NULL,
    "nama" TEXT NOT NULL,
    "deskripsi" TEXT,
    "imageUrl" TEXT,
    "bahan" TEXT[],
    "porsi" INTEGER NOT NULL,
    "langkah" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "resepi_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "resepi_createdAt_idx" ON "resepi"("createdAt");

-- CreateIndex
CREATE INDEX "resepi_nama_idx" ON "resepi"("nama");

-- CreateIndex
CREATE INDEX "resepi_bahan_idx" ON "resepi"("bahan");

-- CreateIndex
CREATE INDEX "resepi_porsi_idx" ON "resepi"("porsi");
