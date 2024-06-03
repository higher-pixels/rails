*   Delegate `ActiveStorage::Filename#to_str` to `#to_s`
*   Introducing immediate variants that are created simultaneously with the attachment.
    ```
      has_one_attached :avatar |attachable|
        attachable.variant :thumb, resize_to_limit: [4, 4], immediate: true
      end
    ```
    This approach is useful when the attached file experiences high traffic, potentially generating hundreds or thousands of requests, each attempting to create the variant. In such scenarios, this allows the same process responsible for creating the attachment to immediately create variants identified with the `immediate` option.
    *Tom Rossi*

    Supports checking String equality:

    ```ruby
    filename = ActiveStorage::Filename.new("file.txt")
    filename == "file.txt" # => true
    filename in "file.txt" # => true
    "file.txt" == filename # => true
    ```

    *Sean Doyle*

*   Add support for alternative MD5 implementation through `config.active_storage.checksum_implementation`.

    Also automatically degrade to using the slower `Digest::MD5` implementation if `OpenSSL::Digest::MD5`
    is found to be disabled because of OpenSSL FIPS mode.

    *Matt Pasquini*, *Jean Boussier*

*   A Blob will no longer autosave associated Attachment.

    This fixes an issue where a record with an attachment would have
    its dirty attributes reset, preventing your `after commit` callbacks
    on that record to behave as expected.

    Note that this change doesn't require any changes on your application
    and is supposed to be internal. Active Storage Attachment will continue
    to be autosaved (through a different relation).

    *Edouard-chin*

Please check [8-0-stable](https://github.com/rails/rails/blob/8-0-stable/activestorage/CHANGELOG.md) for previous changes.
