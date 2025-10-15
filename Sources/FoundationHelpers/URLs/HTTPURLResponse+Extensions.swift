// HTTPURLResponse+Extensions.swift, 15.08.2021.
// Copyright © 2021-2025 Stanislav Lomachinskiy.

#if !os(Linux)
	import Foundation

	/// Response status helpers.
	public extension HTTPURLResponse {

		// MARK: Response Status

		/// A Boolean value indicating whether the response’s HTTP status is Informational (`1xx`).
		var isInformational: Bool {
			100 ... 199 ~= statusCode
		}

		/// A Boolean value indicating whether the response’s HTTP status is Successful (`2xx`).
		var isSuccessful: Bool {
			200 ... 299 ~= statusCode
		}

		/// A Boolean value indicating whether the response’s HTTP status is Redirection (`3xx`).
		var isRedirection: Bool {
			300 ... 399 ~= statusCode
		}

		/// A Boolean value indicating whether the response’s HTTP status is Client Error (`4xx`).
		var isClientError: Bool {
			400 ... 499 ~= statusCode
		}

		/// A Boolean value indicating whether the response’s HTTP status is Server Error (`5xx`).
		var isServerError: Bool {
			500 ... 599 ~= statusCode
		}

		/// A Boolean value indicating whether the response’s HTTP status is Client Error (`4xx`) or Server Error (`5xx`).
		var isError: Bool {
			isClientError || isServerError
		}

	}
#endif
