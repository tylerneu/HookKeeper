CREATE TABLE users (
  id       INTEGER     AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(32) NOT NULL       UNIQUE KEY,
  password VARCHAR(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE roles (
  id    INTEGER     AUTO_INCREMENT PRIMARY KEY,
  role  VARCHAR(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE user_roles (
  user_id  INTEGER,
  role_id  INTEGER,
  UNIQUE KEY user_role (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `user_roles` ADD FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE `user_roles` ADD FOREIGN KEY (role_id) REFERENCES roles (id);

INSERT INTO `roles` (role) VALUES ('admin');