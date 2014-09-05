#include <iostream>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>
#include <assert.h>
#include <cstring>

using namespace std;

void listFiles (string& path) {

	struct stat statistics;

	if (stat (path.c_str(), &statistics)) {
		cout << "Path doesn't exist" << endl;
		return;
	}


	bool isDir = S_ISDIR(statistics.st_mode);
	const char* type = isDir ? "D":"F";
	cout << path <<"," << type << "," << statistics.st_size << endl;

	if (isDir) {
		DIR *dir = opendir (path.c_str());
		assert (dir != NULL);

		struct dirent *entries;
		while ((entries = readdir (dir)) != NULL) {

			if (strcmp (entries->d_name, "."))
			if ((0 == strcmp(entries->d_name,".")) || (0 == strcmp(entries->d_name,"..")))
				continue;

			string filePath = path;
			filePath.append("//",1);
			filePath.append (entries->d_name, strlen (entries->d_name));

			listFiles (filePath);
		}
		closedir (dir);
	}

}

int main (void) {

	string path = "/root/setup";

	listFiles (path);

	return 0;
}
