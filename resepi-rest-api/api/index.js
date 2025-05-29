
const express = require('express');
const dotenv = require('dotenv');
const { PrismaClient } = require('../generated/prisma');


dotenv.config();

const app = express();
const prisma = new PrismaClient();

app.use(express.json());

app.get('/resepi', async (req, res) => {
    const {
        nama,
        bahan,
        porsi,
        sortBy = 'id',
        order = 'asc',
        page = 1,
        limit = 10,
    } = req.query;

    const skip = (page - 1) * limit;
    const take = parseInt(limit);

    const where = {};
    if (nama) {
        where.nama = { contains: nama, mode: 'insensitive' };
    }
    if (bahan) {
        const bahanList = bahan.split(',').map(b => b.trim());
        where.bahan = { hasSome: bahanList };
    }
    if (porsi) {
        where.porsi = parseInt(porsi);
    }

    try {
        const [data, total] = await Promise.all([
            prisma.resepi.findMany({
                where,
                orderBy: { [sortBy]: order.toLowerCase() },
                skip,
                take,
            }),
            prisma.resepi.count({ where }),
        ]);

        return res.status(200).json({
            success: true,
            data,
            pagination: {
                total,
                page: parseInt(page),
                limit: take,
                totalPages: Math.ceil(total / take),
            },
        });
    } catch (error) {
        console.error(error);
        console.log(req.query);
        return res.status(500).json({
            success: false,
            message: 'Internal server error',
        });
    }
});


app.get('/resepi/:id', async (req, res) => {
    const id = parseInt(req.params.id);

    if (isNaN(id)) {
        return res.status(400).json({
            success: false,
            message: 'ID must be a number',
        });
    }

    try {
        const resepi = await prisma.resepi.findUnique({
            where: { id },
        });

        if (!resepi) {
            return res.status(404).json({
                success: false,
                message: 'Resepi not found',
            });
        }

        return res.status(200).json({
            success: true,
            data: resepi,
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            success: false,
            message: 'Internal server error',
        });
    }
});


app.post('/resepi', async (req, res) => {
    const { nama, deskripsi, imageUrl, bahan, porsi, langkah } = req.body;

    if (!nama || !porsi || !Array.isArray(bahan) || !Array.isArray(langkah)) {
        return res.status(400).json({
            success: false,
            message: 'Missing required fields or wrong data type',
        });
    }

    try {
        const newResepi = await prisma.resepi.create({
            data: {
                nama,
                deskripsi,
                imageUrl,
                bahan,
                porsi,
                langkah,
            },
        });

        return res.status(201).json({
            success: true,
            data: newResepi,
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            success: false,
            message: 'Failed to create resepi',
        });
    }
});


app.put('/resepi/:id', async (req, res) => {
    const id = parseInt(req.params.id);
    const { nama, deskripsi, imageUrl, bahan, porsi, langkah } = req.body;

    if (isNaN(id)) {
        return res.status(400).json({
            success: false,
            message: 'ID must be a number',
        });
    }

    if (!nama || !porsi || !Array.isArray(bahan) || !Array.isArray(langkah)) {
        return res.status(400).json({
            success: false,
            message: 'Missing required fields or wrong data type',
        });
    }

    try {
        const updatedResepi = await prisma.resepi.update({
            where: { id },
            data: {
                nama,
                deskripsi,
                imageUrl,
                bahan,
                porsi,
                langkah,
            },
        });

        return res.status(200).json({
            success: true,
            data: updatedResepi,
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            success: false,
            message: 'Failed to update resepi',
        });
    }
});


app.delete('/resepi/:id', async (req, res) => {
    const id = parseInt(req.params.id);

    if (isNaN(id)) {
        return res.status(400).json({
            success: false,
            message: 'ID must be a number',
        });
    }

    try {
        await prisma.resepi.delete({
            where: { id },
        });

        return res.status(200).json({
            success: true,
            message: 'Resepi deleted successfully',
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            success: false,
            message: 'Failed to delete resepi',
        });
    }
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`App Running At http://localhost:${PORT}`);
});