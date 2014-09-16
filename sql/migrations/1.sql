ALTER TABLE `class` 
ADD COLUMN `pull_id` int(11) unsigned NOT NULL,
ADD FOREIGN KEY pull(`pull_id`) REFERENCES `pull`(`id`) ON DELETE CASCADE;