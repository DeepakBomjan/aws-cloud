-- Create the vet_clinic database
CREATE DATABASE vet_clinic;

-- Connect to the vet_clinic database
\c vet_clinic

-- Set permissions for the public schema
GRANT ALL PRIVILEGES ON SCHEMA public TO your_user; -- Replace with your actual username

-- Create the species table
CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100)
);

-- Create the owners table
CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(100),
  age INTEGER,
  email VARCHAR(120)
);

-- Create the vets table
CREATE TABLE vets (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  age INTEGER,
  date_of_graduation DATE
);

-- Create the animals' table
CREATE TABLE animals (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  date_of_birth DATE,
  escape_attempts INTEGER,
  neutered BOOLEAN,
  weight_kg DECIMAL,
  species_id INTEGER REFERENCES species(id),
  owner_id INTEGER REFERENCES owners(id)
);

-- Create the specializations join table
CREATE TABLE specializations (
  vet_id INTEGER REFERENCES vets(id),
  species_id INTEGER REFERENCES species(id),
  PRIMARY KEY (vet_id, species_id)
);

-- Create the visits join table
CREATE TABLE visits (
  animal_id INTEGER REFERENCES animals(id),
  vet_id INTEGER REFERENCES vets(id),
  date_of_visit DATE,
  PRIMARY KEY (animal_id, vet_id, date_of_visit)
);

-- Set indexes
CREATE INDEX ON visits (animal_id);
CREATE INDEX ON visits (vet_id);
CREATE INDEX ON owners (email);

