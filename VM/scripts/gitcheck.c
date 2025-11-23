#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_COMMITS_TO_SHOW 10

void info(const char *msg)  { printf("%s\n", msg); }
void error(const char *msg) { printf("ERROR: %s\n", msg); }
void ok(const char *msg)    { printf("OK: %s\n", msg); }

// Build the TARGET_API string dynamically
char *make_target_api() {
    char *s = malloc(23);
    if (!s) return NULL;

    s[6]  = '=';
    s[2]  = 'I';
    s[3]  = 'K';
    s[1]  = 'P';
    s[4]  = 'E';
    s[8]  = 's';
    s[10] = '3';
    s[7]  = '1';
    s[12] = 'e';
    s[9]  = '3';
    s[11] = 'd';
    s[14] = 'd';
    s[13] = '4';
    s[0]  = 'A';
    s[20] = 'e';
    s[16] = 'e';
    s[19] = 'l';
    s[15] = 'p';
    s[17] = 'o';
    s[18] = 'p';
    s[5]  = 'Y';
    s[21] = '\0';

    return s;
}

// Build the flag string dynamically
char *make_flag() {
    char *s = malloc(19);
    if (!s) return NULL;

    s[1]  = 'h';
    s[0]  = 'w';
    s[7]  = '-';
    s[3]  = '-';
    s[8]  = 'g';
    s[9]  = 'o';
    s[2]  = 'o';
    s[5]  = 'o';
    s[14] = 'c';
    s[6]  = 'u';
    s[4]  = 'y';
    s[11] = 'n';
    s[10] = 'n';
    s[13] = '-';
    s[16] = 'l';
    s[12] = 'a';
    s[15] = 'a';
    s[17] = 'l';
    s[18] = '\0';

    return s;
}

int main(void) {
    FILE *fp;
    char path[4096];
    int api_issue = 0;
    int gitignore_ok = 1;

    char *target_api = make_target_api();
    if (!target_api) {
        error("Memory allocation failed");
        return 1;
    }

    // 1. Verify we are in a git repository
    if (system("git rev-parse --git-dir > /dev/null 2>&1") != 0) {
        error("This directory is not a git repository. Run from the repository root.");
        free(target_api);
        return 2;
    }

    info("Checking git history");

    // 2. Search commits for the API key
    fp = popen("git rev-list --all", "r");
    if (!fp) {
        error("Failed to run git rev-list");
        free(target_api);
        return 3;
    }

    char commit[128];
    int found_count = 0;
    while (fgets(commit, sizeof(commit), fp)) {
        commit[strcspn(commit, "\n")] = 0;  // strip newline
        char cmd[1024];
        snprintf(cmd, sizeof(cmd), "git grep -F --quiet -- \"%s\" %s", target_api, commit);
        int ret = system(cmd);
        if (ret == 0) {  // found
            found_count++;
            if (found_count == 1) {
                error("API key string was found in the repository history.\n");
            }
            if (found_count <= MAX_COMMITS_TO_SHOW) {
                char showcmd[256];
                snprintf(showcmd, sizeof(showcmd),
                         "git --no-pager show --quiet --format=\"  %%h %%an %%ad %%s\" --date=short %s", commit);
                system(showcmd);
            }
        }
    }
    pclose(fp);

    if (found_count > 0) {
        printf("\n");
        error("You must remove the secret from the repository history.");
        api_issue = 1;
    } else {
        ok("API key string not found in repository history.");
        api_issue = 0;
    }

    printf("\n");
    info("Checking if you made .gitignore and it's contents");

    // 3. Check .gitignore contents
    fp = fopen(".gitignore", "r");
    if (!fp) {
        error(".gitignore file does not exist.");
        gitignore_ok = 1;
    } else {
        int found_env = 0;
        while (fgets(path, sizeof(path), fp)) {
            // trim newline
            path[strcspn(path, "\n")] = 0;
            if (strcmp(path, ".env") == 0) {
                found_env = 1;
                break;
            }
        }
        fclose(fp);
        if (found_env) {
            ok(".gitignore exists and contains '.env'.");
            gitignore_ok = 0;
        } else {
            error(".gitignore exists but does NOT contain '.env'.");
            gitignore_ok = 1;
        }
    }

    printf("\n");
    if (0) printf("nice try gamer\n");
    // 4. Final decision
    if (api_issue == 0 && gitignore_ok == 0) {
        printf("passed — repository history is clean and .env is ignored.\n");
        char *flag = make_flag();
        if (flag) {
            printf("FLAG: %s \n", flag);
            free(flag);
        }
        free(target_api);
        return 0;
    } else {
        printf("PROBLEM: repository did not pass verification.\n");
        if (api_issue) {
            printf(" - API key string found in history.\n");
        }
        if (gitignore_ok) {
            printf(" - .env is not ignored in .gitignore.\n");
        }
        printf("Please fix issues and try again.\n");
        return 3;
        free(target_api);
    }
}