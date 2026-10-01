// Dev-only seed: ~8 Dar es Salaam listings for on-device testing.
// Idempotent: fixed ids + ON CONFLICT DO NOTHING. Run with:
//   DATABASE_URL=postgres://kazora:kazora_dev_password@127.0.0.1:5433/kazora \
//     npm run seed:properties --workspace apps/api
import pg from 'pg';

const { Client } = pg;

const listings = [
  {
    id: '10000000-0000-4000-8000-000000000001',
    title: '2BR Apartment in Mikocheni',
    type: 'residential',
    category: 'apartment',
    region: 'Dar es Salaam',
    district: 'Kinondoni',
    area: 'Mikocheni',
    price_tzs: 650000,
    photos: 'https://picsum.photos/seed/kazora-mikocheni/600/400',
    status: 'available',
    bedrooms: 2,
    bathrooms: 2,
    furnished: false,
    amenities: 'parking,water,security',
    is_verified: true,
    is_featured: true,
    description: 'Spacious 2 bedroom apartment near Mikocheni shops.',
  },
  {
    id: '10000000-0000-4000-8000-000000000002',
    title: 'Furnished Studio in Msasani',
    type: 'residential',
    category: 'apartment',
    region: 'Dar es Salaam',
    district: 'Kinondoni',
    area: 'Msasani Peninsula',
    price_tzs: 900000,
    photos: 'https://picsum.photos/seed/kazora-msasani/600/400',
    status: 'available',
    bedrooms: 1,
    bathrooms: 1,
    furnished: true,
    amenities: 'parking,water,security,gym,pool',
    is_verified: true,
    is_featured: true,
    description: 'Modern furnished studio minutes from the beach.',
  },
  {
    id: '10000000-0000-4000-8000-000000000003',
    title: 'Single Room in Temeke',
    type: 'residential',
    category: 'room',
    region: 'Dar es Salaam',
    district: 'Temeke',
    area: 'Mbagala',
    price_tzs: 120000,
    photos: 'https://picsum.photos/seed/kazora-mbagala/600/400',
    status: 'available',
    bedrooms: 1,
    bathrooms: 1,
    furnished: false,
    amenities: 'water,security',
    is_verified: true,
    is_featured: false,
    description: 'Affordable single room with shared kitchen.',
  },
  {
    id: '10000000-0000-4000-8000-000000000004',
    title: '3BR House in Gongo la Mboto',
    type: 'residential',
    category: 'house',
    region: 'Dar es Salaam',
    district: 'Ilala',
    area: 'Gongo la Mboto',
    price_tzs: 850000,
    photos: 'https://picsum.photos/seed/kazora-gongo/600/400',
    status: 'available',
    bedrooms: 3,
    bathrooms: 2,
    furnished: false,
    amenities: 'parking,water,security,garden',
    is_verified: false,
    is_featured: false,
    description: 'Family house with garden, quiet street.',
  },
  {
    id: '10000000-0000-4000-8000-000000000005',
    title: 'Office Space on Sam Nujoma Rd',
    type: 'commercial',
    category: 'office',
    region: 'Dar es Salaam',
    district: 'Ubungo',
    area: 'Ubungo',
    price_tzs: 1500000,
    photos: 'https://picsum.photos/seed/kazora-ubungo/600/400',
    status: 'available',
    bedrooms: 0,
    bathrooms: 2,
    furnished: false,
    amenities: 'parking,security,generator,elevator',
    is_verified: true,
    is_featured: true,
    description: 'Open-plan office with backup generator.',
  },
  {
    id: '10000000-0000-4000-8000-000000000006',
    title: 'Shop in Kariakoo Market Area',
    type: 'commercial',
    category: 'shop',
    region: 'Dar es Salaam',
    district: 'Ilala',
    area: 'Kariakoo',
    price_tzs: 700000,
    photos: 'https://picsum.photos/seed/kazora-kariakoo/600/400',
    status: 'available',
    bedrooms: 0,
    bathrooms: 1,
    furnished: false,
    amenities: 'security,storage',
    is_verified: true,
    is_featured: false,
    description: 'High-foot-traffic retail shop near the market.',
  },
  {
    id: '10000000-0000-4000-8000-000000000007',
    title: '2BR in Kigamboni Ferry Area',
    type: 'residential',
    category: 'apartment',
    region: 'Dar es Salaam',
    district: 'Kigamboni',
    area: 'Ferry',
    price_tzs: 450000,
    photos: 'https://picsum.photos/seed/kazora-kigamboni/600/400',
    status: 'available',
    bedrooms: 2,
    bathrooms: 1,
    furnished: false,
    amenities: 'water,security',
    is_verified: false,
    is_featured: false,
    description: 'Breezy apartment a short walk from the ferry.',
  },
  {
    id: '10000000-0000-4000-8000-000000000008',
    title: 'Masters Bedroom in Sinza',
    type: 'residential',
    category: 'room',
    region: 'Dar es Salaam',
    district: 'Ubungo',
    area: 'Sinza',
    price_tzs: 250000,
    photos: 'https://picsum.photos/seed/kazora-sinza/600/400',
    status: 'available',
    bedrooms: 1,
    bathrooms: 1,
    furnished: true,
    amenities: 'parking,water,security,wifi',
    is_verified: true,
    is_featured: true,
    description: 'Self-contained furnished room, ideal for professionals.',
  },
];

const client = new Client({
  connectionString:
    process.env.DATABASE_URL ??
    'postgres://kazora:kazora_dev_password@127.0.0.1:5433/kazora',
});

await client.connect();
let inserted = 0;
const VIDEO_TOUR_URL =
  'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4';

for (const row of listings) {
  const seedName = row.photos.match(/seed\/([^/]+)/)[1];
  const photos = [seedName, `${seedName}-bedroom`, `${seedName}-kitchen`]
    .map((s) => `https://picsum.photos/seed/${s}/600/400`)
    .join(',');
  const result = await client.query(
    `INSERT INTO properties
      (id, title, type, category, region, district, area, price_tzs, photos,
       status, bedrooms, bathrooms, furnished, amenities,
       is_verified, is_featured, description, video_url)
     VALUES
      ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18)
     ON CONFLICT (id) DO UPDATE SET
       photos = EXCLUDED.photos,
       video_url = EXCLUDED.video_url`,
    [
      row.id,
      row.title,
      row.type,
      row.category,
      row.region,
      row.district,
      row.area,
      row.price_tzs,
      photos,
      row.status,
      row.bedrooms,
      row.bathrooms,
      row.furnished,
      row.amenities,
      row.is_verified,
      row.is_featured,
      row.description,
      VIDEO_TOUR_URL,
    ],
  );
  inserted += result.rowCount ?? 0;
}
const { rows } = await client.query('SELECT count(*)::int AS n FROM properties');
console.log(`synced ${inserted} listings (total ${rows[0].n})`);
await client.end();
