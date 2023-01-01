from typing import Dict, List

class HermesException(Exception):
    def pretty_print_str(self):
        err = f"[bold][red]HermesException: {str(self)}[/red][/bold]"
        return err

class ChecksumMismatchException(HermesException):
    def pretty_print_str(self):
        err = f"[red][bold]:x: ChecksumMismatchException:[/bold] {str(self)}[/red]"
        err += "\n[bold][red]Please re-run the transfer due to checksum mismatch at the destination object store.[/red][/bold]"
        return err
