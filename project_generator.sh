#!/bin/bash

create_server_directory() {
    mkdir server
    cd server
    npm init -y
    npm install express cors dotenv
    npm install --save-dev nodemon
    mkdir models public routes services
    cat <<EOF > index.js
const express = require('express');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

EOF
    if [ "$db_type" == "mongodb" ]; then
        npm install mongoose
        cat <<EOF >> index.js
const mongoose = require('mongoose');

mongoose.connect('mongodb://127.0.0.1:27017/$main_file_name');
const connection = mongoose.connection;
connection.once('open', () => {
    console.log('MongoDB database connection established successfully');
});
EOF
    elif [ "$db_type" == "postgresql" ]; then
        npm install pg
        cat <<EOF >> index.js
const { Pool } = require('pg');

const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT || 5432,
});

// PostgreSQL code using 'pool' object
EOF
    fi

    cat <<EOF >> index.js

app.listen(port, () => {
    console.log('Server is running on port: ' + port);
});
EOF

    cat <<EOF > .gitignore
/node_modules
EOF

    cd models
    cat <<EOF > index.js
EOF

    if [ "$db_type" == "mongodb" ]; then
        cat <<EOF >> index.js
const mongoose = require('mongoose');
EOF
    elif [ "$db_type" == "postgresql" ]; then
        cat <<EOF >> index.js
// PostgreSQL model configuration code here
EOF
    fi

    cat <<EOF > example.js
const { Schema } = require('mongoose');

const Example = new Schema({
    id: {
        type: Number,
        required: true,
    },
    nome: {
        type: String,
        required: true,
    },
});

module.exports = Example;
EOF

    cd ..
    cd routes
    mkdir api auth middlewares
    echo $'const express = require("express");\n\nconst router = express.Router();\n\nrouter.get("/", (_, res) => {\n    res.send("<h1>Home</h1>");\n});\n\nmodule.exports = router;' > home.js
    cd ../..
}

create_client_directory() {
    npm install create-react-app
    npx create-react-app client
}

create_readme() {
    echo "# $main_file_name" > README.md
    echo "" >> README.md
    echo "## Basic Features" >> README.md
    echo "Here are some of the basic features included in this project:" >> README.md
    echo "- Feature 1: Node.js/Express server." >> README.md
    echo "- Feature 2: $db_type database." >> README.md
    echo "- Feature 3: React-create-app for Frontend." >> README.md
    echo "- Feature 4: Command to start both client and server." >> README.md
    echo "" >> README.md
    echo "README file created successfully!"
}

git_init() {
  git init
}

if [ -z "$1" ]; then
    read -p "Please provide a main file name: " main_file_name
    if [ -z "$main_file_name" ]; then
        echo "Error: Must provide a directory name"
        exit 1
    fi
else
    main_file_name=$1
fi

if [ -z "$2" ]; then
    read -p "Please select the database type (1: MongoDB, 2: PostgreSQL): " db_option
    if [ "$db_option" == "1" ]; then
        db_type="mongodb"
    elif [ "$db_option" == "2" ]; then
        db_type="postgresql"
    else
        echo "Invalid database option selected."
        exit 1
    fi
else
    if [ "$2" == "1" ]; then
        db_type="mongodb"
    elif [ "$2" == "2" ]; then
        db_type="postgresql"
    else
        echo "Invalid database option selected."
        exit 1
    fi
fi

if [ $# -gt 2 ]; then
    if ! [ -d "$3" ]; then
        echo "Invalid path, creating in current directory"
    else
        cd "$3"
    fi
fi

mkdir "$main_file_name"
cd "$main_file_name"

touch .env .env.example
npm init -y

echo "Creating client directory..."
create_client_directory

echo "Creating server directory..."
create_server_directory

echo "Creating start command..."
sed -i '/exit 1\"/s/$/,\n    "start": "start cmd.exe \/c \\"cd client \&\& start cmd.exe \/k npm start\\" \& start cmd.exe \/c \\"cd server \&\& start cmd.exe \/k node index.js\\"" /' package.json

echo "Creating README file..."
create_readme

echo "Initializing git..."
git_init

echo "Basic MERN stack file structure created successfully!"
echo "Script executed in $(($SECONDS / 3600))h$((($SECONDS / 60) % 60))m$(($SECONDS % 60))s"
