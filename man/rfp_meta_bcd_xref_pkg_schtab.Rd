% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rfp_meta_bcd_xref_pkg_schtab.R
\name{rfp_meta_bcd_xref_pkg_schtab}
\alias{rfp_meta_bcd_xref_pkg_schtab}
\title{Create a table that cross references the package name with the object_name.}
\usage{
rfp_meta_bcd_xref_pkg_schtab(pkg_list = NULL, pkg_name = NULL, row_idx = NULL)
}
\arguments{
\item{pkg_list}{A list of complete metadata by package.}

\item{pkg_name}{A character string specifying the package name.}

\item{row_idx}{A numeric value specifying the row index.}
}
\value{
A tibble with columns object_name and package_name.
}
\description{
Helper function used in /link{rfp_meta_bcd_xref} to drill down through each package to get the object_name from the
resource_df using a row index gathered by rfp_meta_bcd_xref. This is used to apply the row index of the row that
contains the wms resource within the package as there are other datasets within the same package and we want the
schema.table for a dataset downloaded from the wms service.
}
\seealso{
Other meta bcdata: 
\code{\link{rfp_meta_bcd_xref}()},
\code{\link{rfp_meta_bcd_xref_col_comments}()}
}
\concept{meta bcdata}
