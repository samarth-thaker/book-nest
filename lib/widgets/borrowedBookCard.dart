import 'package:booknest/models/bookModel.dart';
import 'package:booknest/providers/bookProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BorrowedBookCard extends StatelessWidget {
  final Book book;
  
  const BorrowedBookCard({Key? key, required this.book}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isOverdue = book.expectedReturnDate != null && 
        book.expectedReturnDate!.isBefore(DateTime.now());
    
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book title and author
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'by ${book.author}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            
            // Borrower info
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 4),
                Text('Borrowed from: ${book.borrowedFromPersonName}'),
              ],
            ),
            
            // Lent date
            if (book.borrowedDate != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text('Borrowed on: ${_formatDate(book.borrowedDate!)}'),
                ],
              ),
            
            // Due date with overdue indicator
            if (book.expectedReturnDate != null)
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: isOverdue ? Colors.red : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Due: ${_formatDate(book.expectedReturnDate!)}',
                    style: TextStyle(
                      color: isOverdue ? Colors.red : Colors.grey[600],
                      fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (isOverdue) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'OVERDUE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            
            const SizedBox(height: 12),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Contact borrower button
                /* if (book.borrowerContact != null)
                  TextButton.icon(
                    onPressed: () {
                      // Launch phone or messaging app
                      _contactBorrower(book.borrowerContact!);
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Contact'),
                  ), */
                
                // Send reminder button
                TextButton.icon(
                  onPressed: () {
                    _sendReminder(context, book);
                  },
                  icon: const Icon(Icons.notifications),
                  label: const Text('Remind'),
                ),
                
                // Mark as returned button
                ElevatedButton.icon(
                  onPressed: () {
                    _markAsReturned(context, book);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Returned'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  
  
  void _sendReminder(BuildContext context, Book book) {
  
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder sent to ${book.borrowedFromPersonName}'),
      ),
    );
  }
  
  void _markAsReturned(BuildContext context, Book book) {
    /* Provider.of<BookProvider>(context, listen: false)
                  .markBorrowedBookAsReturned(book);
 */
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Returned'),
        content: Text('Mark "${book.title}" as returned by ${book.borrowedFromPersonName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),

        ],
      ),
    );
  }
}