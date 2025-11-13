#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>

int directory_exists(const char *path) {
    struct stat st;
    return (stat(path, &st) == 0 && (st.st_mode & S_IFDIR));
}

int file_exists(const char *path) {
    struct stat st;
    return (stat(path, &st) == 0 && (st.st_mode & S_IFREG));
}

int remove_path(const char *path) {
    char cmd[512];
    snprintf(cmd, sizeof(cmd), "rm -rf %s", path);
    return system(cmd);
}

int main(void) {
    // Change directory to /home/vagrant/project
    if (chdir("/home/vagrant/project") != 0) {
        perror("Failed to change directory to /home/vagrant/project");
        return 1;
    }

    // Check if .git directory exists; if yes, remove .git and .env
    if (directory_exists(".git")) {
        if (remove_path(".git") != 0) {
            fprintf(stderr, "Failed to remove .git directory\n");
            return 1;
        }
        if (file_exists(".env")) {
            if (remove_path(".env") != 0) {
                fprintf(stderr, "Failed to remove .env file\n");
                return 1;
            }
        }
        if (file_exists(".gitignore")) {
            if (remove_path(".gitignore") != 0) {
                fprintf(stderr, "Failed to remove ignore file\n");
                return 1;
            }
        }
    }

    // Initialize a new git repository
    if (system("git init") != 0) {
        fprintf(stderr, "Failed to run git init\n");
        return 1;
    }

    // Set git username
    if (system("git config user.name \"Kalma Vakinen\"") != 0) {
        fprintf(stderr, "Failed to set git username\n");
        return 1;
    }

    // Add and commit app.py
    if (system("git add app.py") != 0) {
        fprintf(stderr, "Failed to git add app.py\n");
        return 1;
    }
    if (system("git commit -m \"Initial commit\"") != 0) {
        fprintf(stderr, "Failed to git commit app.py\n");
        return 1;
    }

    // Create .env file with content
    FILE *f = fopen(".env", "w");
    if (!f) {
        perror("Failed to create .env file");
        return 1;
    }
    if (fprintf(f, "APIKEY=1s33de4dpeople\n") < 0) {
        perror("Failed to write to .env file");
        fclose(f);
        return 1;
    }
    fclose(f);

    // Stage and commit the .env file
    if (system("git add .env") != 0) {
        fprintf(stderr, "Failed to git add .env\n");
        return 1;
    }
    if (system("git commit -m \"this is sin\"") != 0) {
        fprintf(stderr, "Failed to git commit\n");
        return 1;
    }

    printf("Git repository initialized and committed .env successfully.\n");
    return 0;
}