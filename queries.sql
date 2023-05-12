/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT name FROM animals WHERE data_of_birth BETWEEN '2016-01-01' AND '2019-01-01';
SELECT name FROM animals WHERE neutered = true  AND escape_attempts < 3;
SELECT data_of_birth FROM animals WHERE name IN('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN;
UPDATE animals
SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon%';
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals
WHERE data_of_birth > '2022-01-01';
SAVEPOINT SP1;
UPDATE animals
SET weight_kg = weight_kg * -1;
ROLLBACK TO SP1;
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, AVG(escape_attempts) AS avg_escape_attempts FROM animals 
GROUP BY neutered;

SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) AS avg_escape_attempts FROM animals
WHERE data_of_birth BETWEEN '1990-01-01' AND '2000-12-30'
GROUP BY species;

SELECT name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE full_name = 'Melody Pond';

SELECT animals.name FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

SELECT full_name, name FROM animals
RIGHT JOIN owners ON animals.owner_id = owners.id;

SELECT species.name, COUNT(*) FROM animals
JOIN species ON animals.species_id = species.id
GROUP BY species.name;

SELECT animals.name FROM animals
JOIN owners ON animals.owner_id = owners.id
JOIN species ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell'
AND species.name = 'Digimon';

SELECT animals.name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester'
AND animals.escape_attempts = 0;

SELECT owners.full_name, COUNT(*) FROM animals
JOIN owners ON animals.owner_id = owners.id
GROUP BY owners.full_name;

-- Who was the last animal seen by William Tatcher?

SELECT a.name AS name_of_animal, v.date_of_visit FROM animals a 
JOIN visits v ON a.id = v.animal_id
WHERE v.vet_id = (SELECT id FROM vets WHERE vets.name = 'William Tatcher')
ORDER BY v.date_of_visit DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?

SELECT v.name, COUNT(*) FROM visits vs
JOIN vets v ON v.id = vs.vet_id
WHERE vs.vet_id = (SELECT id FROM vets WHERE vets.name = 'Stephanie Mendez')
GROUP BY vs.vet_id, v.name;

-- List all vets and their specialties, including vets with no specialties.

SELECT v.name, species.name FROM vets v 
LEFT JOIN specializations s ON v.id = s.vet_id
LEFT JOIN species ON species.id = s.species_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.

SELECT a.name, v.date_of_visit FROM animals a 
JOIN visits v ON a.id = v.animal_id
WHERE v.vet_id = (SELECT id FROM vets WHERE vets.name = 'Stephanie Mendez')
AND v.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?

SELECT a.name, COUNT(*) AS number_of_visits FROM animals a
JOIN visits v ON a.id = v.animal_id
GROUP BY v.animal_id, a.name
ORDER BY number_of_visits DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?

SELECT a.name, v.date_of_visit FROM animals a
JOIN visits v ON a.id = v.animal_id
WHERE v.vet_id = (SELECT id FROM vets WHERE vets.name = 'Maisy Smith')
ORDER BY v.date_of_visit
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.

SELECT a.name AS animal, v.name AS vet, vs.date_of_visit FROM animals a
JOIN visits vs ON a.id = vs.animal_id
JOIN vets v ON v.id = vs.vet_id
ORDER BY vs.date_of_visit DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?

SELECT v.name, COUNT(*) FROM vets v
JOIN visits vs ON v.id = vs.vet_id
WHERE vs.vet_id = (SELECT id FROM vets WHERE vets.name = 'Maisy Smith')
GROUP BY vs.vet_id, v.name;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.

SELECT s.name, COUNT(*) FROM visits vs 
JOIN vets v ON v.id = vs.vet_id
JOIN animals a ON a.id = vs.animal_id
JOIN species s ON s.id = a.species_id
WHERE v.name = 'Maisy Smith'
GROUP BY s.name
LIMIT 1;