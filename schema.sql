/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255),
  data_of_birth DATE,
  escape_attempts INT,
  neutered BOOLEAN,
  weight_kg DECIMAL(5,2),
  species_id INT FOREIGN KEY REFERENCES species(id),
  owner_id INT FOREIGN KEY REFERENCES owners(id),
  PRIMARY KEY(id)
);

CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    age INT
);

CREATE TABLE species ( 
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);
