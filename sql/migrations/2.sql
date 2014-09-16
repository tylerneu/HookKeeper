ALTER TABLE `tractor` 
ADD COLUMN `class_id` int(11) unsigned NOT NULL,
ADD FOREIGN KEY class(`class_id`) REFERENCES `class`(`id`) ON DELETE CASCADE;