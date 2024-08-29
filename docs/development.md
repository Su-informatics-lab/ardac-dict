# Modifying the dictionary

Use the following steps to make bug fixes or feature enhancements to the dictionary.

## Step 1: Clone the repository
Begin by cloning the repository to your local machine.

```bash
git clone git@github.com:Su-informatics-lab/ardac-dict.git
```

> [!NOTE]
> The example above assumes that you are working from the command line and have SSH keys set up with GitHub. If you are using the GitHub desktop application or VSCode, you can clone the repository using the HTTPS URL instead.

## Step 2: Create a new branch
Create a new branch for your changes. The branch name should be descriptive of the changes you are making. If it is a bug fix, consider something like `bug/fix-node-properties`. If it is a feature enhancement, consider something like `feat/new-file-type`.

```bash
git checkout -b feat/new-file-type
```

## Step 3: Make your changes
Make your changes to the dictionary. Be sure to follow the [Gen3 Data Dictionary](https://gen3.org/resources/user/dictionary/) documentation for best practices.

## Step 4: Add a tag
When you are finished with your changes, add a tag. This will be included as a version identifier in the `schema.json` file when you validate and deploy the dictionary. This is especially useful during testing as it allows you to easily identify the version of the dictionary that you are working with in your Gen3 deployment.

```bash
git tag 2.1.0-jn-new-file-type
```

> [!NOTE]
> This is a "lightweight" tag that is used during testing and development. When the branch is merged into `main`, a tag and release should be created to identify the new version of the dictionary (see below).

## Step 5: Validate your changes
Before committing your changes, validate the dictionary using the `dictutils` tool. This tool will check for common errors and also outputs a `schema.json` file that can be used to deploy the dictionary for initial testing.

> [!IMPORTANT]
> It is strongly recommended that you run the dictutils from the root of the repository, as demonstrated below. This will ensure that the tool can find all of the necessary files. See the [dictionaryutils](https://github.com/Su-informatics-lab/ardac/tree/master/dictionaryutils) documentation for more information.

```bash
docker run --rm -v $(pwd):/mnt/host quay.io/rds/dictutils
```

> [!NOTE]
> You can alias this command in your shell to make it easier to run. For example, you could add the following to your `.bashrc` or `.bash_profile` file:
> ```bash
> validate() { docker run --rm -v $(pwd):/mnt/host quay.io/rds/dictutils; }
> ```
> Then you can run the command by typing `validate` in the terminal.

## Step 6: Commit your changes
After you inspect the `schema.json` file and are satisfied with the changes, commit your changes to the repository. This will allow you to push your new `schema.json` file to the remote repository on your branch, making it available for deployments in a Gen3 environment.

```bash
git add .
git commit -m "feat: Add new file type"
git push origin feat/new-file-type
```

> [!NOTE]
> After the push, your dictionary should be available at a URL like `https://raw.githubusercontent.com/Su-informatics-lab/ardac-dict/feat/new-file-type/schema.json`. You can use this URL to test your changes in a Gen3 environment.

## Step 7: Merge your changes
When you are satisfied with your changes and have tested them in a Gen3 environment, merge your changes into the `main` branch. This will trigger a new release of the dictionary. Because the main branch is protected, you will need to create a pull request and have it reviewed by a team member. This process is most easily accomplished using the GitHub web interface or the GitHub desktop application.

## Step 8: Create a release
After your changes have been merged into the `main` branch, create a new release. This will tag the release with a version number and make it available for deployment in a Gen3 environment.

1. Go to the [releases page](https://github.com/Su-informatics-lab/ardac-dict/releases) for the repository.
2. Click the "Draft a new release" button.
3. Enter the appropriate version number by clicking on the `Choose a tag` dropdown. Follow the [Semantic Versioning](https://semver.org/) guidelines. If this is a bug fix, increment the patch version (e.g., `2.0.1`). If this is a feature enhancement, increment the minor version (e.g., `2.1.0`). If this is a breaking change, increment the major version (e.g., `3.0.0`).
4. Enter a title for the release. This should be the same as the version number.
5. Enter a description of the changes that were made in this release. This should be a summary of the changes that were made in the branch that was merged into `main`.
6. Click the "Publish release" button.

## Step 9: Deploy the dictionary
After the release has been created, the dictionary will be available at a URL like `https://dictionary.ardac.org/2.1.0/schema.json`. You can use this URL to deploy the dictionary in a Gen3 environment.

