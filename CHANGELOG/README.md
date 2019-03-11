# Changelog

### [v0.3 - 11/mar/19] > User settings release

- Patch `user controller` to face account deletion requests upon account authentication. User messages will be deleted with the user.
- Break `/account` view into several small partials for better organisation.
- Patch `routes` to accept and direct the new requests.
- Patch `gitignore` to correctly ignore `*.rdb` cache dumps extensions.


### [v0.2 - 08/mar/19] > User settings frontend initiation

- Add new stylesheet `account.scss` to the pipeline.
- Instantiate the responsive template for the account settings view.


### [v0.1 - 08/mar/19] > Initial commit

- Initial system released.
