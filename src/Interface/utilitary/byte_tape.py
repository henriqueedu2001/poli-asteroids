import os
from typing import List
from typing import Union
from . binary_handler import BinaryHandler

DEFAULT_DATADIR_NAME = '.bytetapes'

class ByteTape():
    def __init__(self) -> None:
        self.index = 0
        self.content = None
        self.tape_length = 0
        self.loaded_tape = False
        
        self.data_dir_path = data_dir_path()
        self.check_data_dir_exist()
        
        return
    

    def read_byte(self) -> bytes:
        if self.loaded_tape:
            byte = self.content[self.index]
            self.index = self.next_index()     
            
            return byte
        
        return None
    
    
    def read_bytes(self, n=64) -> bytes:
        if self.loaded_tape:
            bytes = []
            
            # ler n bytes de dados
            for _ in range(n):
                byte = self.content[self.index]
                bytes.append(byte)
                self.index = self.next_index()     
            
            return bytes
        
        return None
    
    
    def set_tape(self, byte_tape: bytes) -> None:
        tape = [BinaryHandler.get_byte(byte) for byte in byte_tape]
        
        self.content = tape
        self.tape_length = len(tape)
        self.loaded_tape = True
        
        return
    
    
    def save_tape(self, name='out_default', extension='.bin', encoding='hex') -> None:
        abs_path = get_byte_tape_path(name, extension)
        
        with open(abs_path, 'w') as file:
            content = self.encoded_content(encoding)
            file.write(content)
        
        return
    
    
    def load_tape(self, name='in_default', extension='.bin') -> None:
        abs_path = get_byte_tape_path(name, extension)
        
        with open(abs_path, 'r') as file:
            content = file.read()
            decoded_content = self.decode_content(content, encoding='hex')
            
            self.content = decoded_content
            self.loaded_tape = True
            self.tape_length = len(decoded_content)
        
        return
    
    
    def encoded_content(self, encoding='hex'):
        str_content = BinaryHandler.get_byte_data_str(self.content)
        
        return str_content
    
    
    def decode_content(self, content, encoding='hex'):
        str_content = BinaryHandler.get_bytes_from_str(content)
        
        return str_content
    
    
    
    def print_tape(self, bytes_per_line: int = 16, str_format: str = 'hex') -> None:
        if self.loaded_tape:
            BinaryHandler.print_byte_data(self.content, str_format=str_format)
        else:
            print('tape not loaded')
        return
    
    
    def next_index(self):
        i = self.index
        i = (i + 1) % self.tape_length
        
        return i
    
    
    def check_data_dir_exist(self):
        if self.data_dir_exists() == False:
            self.create_data_dir()
        
        return
    
    
    def data_dir_exists(self):
        data_dir = self.data_dir_path
        
        if os.path.exists(data_dir):
            return True
        
        return False
    
    
    def create_data_dir(self):
        data_dir = data_dir_path()
        os.makedirs(data_dir)


def this_dir_path():
    this_dir = os.path.dirname(os.path.abspath(__file__))
    
    return this_dir


def data_dir_path():
    this_dir = this_dir_path()
    data_dir = os.path.join(this_dir, DEFAULT_DATADIR_NAME)
    
    return data_dir


def get_byte_tape_path(name, extension):
    data_dir = data_dir_path()
    filename = get_filename(name, extension)
    
    abs_path = os.path.join(data_dir, filename)
    
    return abs_path


def get_filename(name, extension):
    ext = extension
    
    if ext[0] == '.':
        ext = ext[1:]
        
    filename = f'{name}.{ext}'
    
    return filename