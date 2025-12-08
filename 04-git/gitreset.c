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

char *make_api_key_line() {
    char *s = malloc(23 + 1);
    if (!s) return NULL;

    s[0]  = 'A';
    s[5]  = 'Y';
    s[1]  = 'P';
    s[2]  = 'I';
    s[3]  = 'K';
    s[4]  = 'E';

    s[12] = 'd';
    s[6]  = '=';
    s[7]  = '1';
    s[10] = '3';
    s[11] = '3';
    s[9]  = '4';
    s[8]  = 's';
    s[13] = 'e';
    s[14] = 'd';
    s[18] = 'p';
    s[15] = 'p';
    s[17] = 'o';
    s[16] = 'e';
    s[20] = 'e';
    s[19] = 'l';

    s[21] = '\n';
    s[22] = '\0';

    return s;
}

int main(void) {
    // Change directory to /home/kali/project
    if (chdir("/home/kali/project") != 0) {
        perror("Failed to change directory to /home/kali/project");
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
    char *api_line = make_api_key_line();
    if (!api_line) {
        perror("Failed to allocate API key string");
        fclose(f);
        return 1;
    }

    if (fprintf(f, "%s", api_line) < 0) {
        perror("Failed to write to .env file");
        free(api_line);
        fclose(f);
        return 1;
    }
    free(api_line);
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