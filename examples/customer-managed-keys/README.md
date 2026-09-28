# Customer managed keys

This example encrypts the managed services data with a customer managed key.

The azure databricks service principal is granted crypto permissions on the key vault before the
workspace is created. Managed disk and root dbfs encryption are not part of this example, as both
require key permissions for an identity that only exists after the workspace is created.
