// import 'dart:html' as html;
//
// import 'dart:typed_data';
//
// Future<void> downloadJmiPdf() async {
//   final Uint8List pdfBytes = await jmiPdf();
//   // print('--Uint8List-----');
//   // print(pdfBytes.runtimeType);
//
//   // Create a blob from the PDF bytes
//   final blob = html.Blob([pdfBytes]);
//
//   // Create a download link
//   final url = html.Url.createObjectUrlFromBlob(blob);
//   final anchor = html.AnchorElement(href: url)
//     ..setAttribute('download', 'jml.pdf')
//     ..text = 'Download PDF';
//
//   // Append the anchor element to the body
//   html.document.body?.append(anchor);
//
//   // Click the anchor to initiate download
//   anchor.click();
//
//   // Clean up resources
//   html.Url.revokeObjectUrl(url);
//   anchor.remove();
// }
//
// Future<Uint8List> jmiPdf() async {
//   // Replace this with your actual PDF fetching logic
//   // This is a placeholder example using a sample PDF URL
//   final response = await html.HttpClient().getUrl(Uri.parse('https://example.com/sample.pdf')).then((request) => request.close());
//   return await response.bytes.toList();
// }