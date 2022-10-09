#!/usr/bin/env python3

from pathlib import Path
from tempfile import mkstemp
import sys
import subprocess

def main() -> int:
    target = Path(sys.argv[1])
    bak = Path(sys.argv[2])
    exclusion = sys.argv[3].splitlines()
    orig = target.read_text()
    new, notfound = reduce(orig, exclusion)
    print(notfound)
    if orig == new:
        print('unchanged')
        return 0
    try:
        prebak = bak.read_text()
    except FileNotFoundError:
        prebak = ''
    bak.write_text(orig)
    target.write_text(new)
    if not valid(target):
        target.write_text(orig)
        bak.write_text(prebak)
        (f, p) = mkstemp()
        f.write_text(new)
        print(p)
        return 1
    return 0

def reduce(orig, exclusion):
    blocks = split_blocks(orig)
    block_signatures = [parse_block(b) for b in blocks]
    filtered, notfound = filter_blocks(blocks, block_signatures, exclusion)
    return join_blocks(filtered), notfound

def split_blocks(s):
    xs = list(s.split('\n\n'))
    if len(xs) == 0: return xs
    return [x + '\n' for x in xs[:-1]] + xs[-1:]

def join_blocks(blocks):
    return '\n'.join(blocks)

def parse_block(block):
    lines = block.splitlines()
    au = (l for l in lines if l.startswith('au Buf') or l.startswith('autocmd Buf'))
    return [a.split()[2] for a in au]

def filter_blocks(blocks, block_signatures, exclusion):
    notfound = [True for _ in exclusion]
    filtered = []
    for (b, ss) in zip(blocks, block_signatures):
        exclude = False
        for s in ss:
            for i, e in enumerate(exclusion):
                if s == e:
                    exclude = True
                    notfound[i] = False
                    break
        if not exclude:
            filtered.append(b)
    return filtered, [e for (e, nf) in zip(exclusion, notfound) if nf]

def valid(target):
    p = subprocess.run(
            ['nvim', '--headless', '-c', 'message', '-c', 'q'],
            encoding='utf-8', stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return str(target) not in p.stdout and str(target) not in p.stderr

if __name__ == "__main__":
    exit(main())
