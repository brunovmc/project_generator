markdown
Copy code

# Project Structure Generator

This script generates a basic full-stack project structure, including a frontend and backend setup for a custom full-stack project.

## Usage

To use this script, run the following command in your terminal:

```bash
sh project_generator.sh <main_file_name> [<directory_path>]
```

- <main_file_name>: Required argument. The name of your main file. This will be used as the name of your project directory.

- [<directory_path>]: Optional argument. The path where the project directory will be created. If not provided, the project directory will be created in the current directory. If the provided directory does not exist, the project directory will be created in the current directory.

Examples:

```bash
sh project_generator.sh myapp                      # Creates the directory 'myapp' in the current directory
sh project_generator.sh myapp /path/to/directory   # Creates the directory 'myapp' in the '/path/to/directory' directory
```

## Database Selection

During the execution of the script, you will be prompted to select the database type. Please choose one of the following options:

##### 1 - MongoDB

##### 2 - PostgreSQL

## Running the Client and Server

After running the script and entering the created directory, you can run the following command in the main directory to start the client and server:

```sql
npm start
```

This will create two terminals, one for the client and one for the server.

## Credits

This script was created by Bruno Coriolano.
