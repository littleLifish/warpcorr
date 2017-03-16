# find alignments of reads, find positions of matches and mismatches

import sys
import numpy

# input a single read!!!
readin = []
read = sys.stdin.readlines()
#for line in read:
#    readin.append[line]

#read1 = open('1.fa','r')
#read2 = open('2.fa','r')
#read3 = open('3.fa','r')
read_ref = open('lambda_ref_genome.fasta','r')
#ref_alt = open('Lambda_ref_alt.fasta','r')
#code as given to us in homework five for parsing fastas
def parse_fasta(fh):
    fa = {}
    current_short_name = None
    # Part 1: compile list of lines per sequence
    for ln in fh:
        if ln[0] == '>':
            # new name line; remember current sequence's short name
            long_name = ln[1:].rstrip()
            current_short_name = long_name.split()[0]
            fa[current_short_name] = []
        else:
            # append nucleotides to current sequence
            fa[current_short_name].append(ln.rstrip())
    # Part 2: join lists into strings
    for short_name, nuc_list in fa.iteritems():
        # join this sequence's lines into one long string
        fa[short_name] = ''.join(nuc_list)
    return fa

seq = parse_fasta(read)
seqref = parse_fasta(read_ref)

seqname = ''
for key, value in seq.iteritems():
    seqname = str(key)
sequenceread = seq[seqname]
print sequenceread
sequenceref = seqref['J02459.1']

# code here given to us from the IPython Notebook Edit_DP
# Assume x is the string labeling rows of the matrix and y is the
# string labeling the columns

def trace(D, x, y):
    ''' Backtrace edit-distance matrix D for strings x and y '''
    i, j = len(x), len(y)
    xscript = []
    while i > 0:
        diag, vert, horz = sys.maxint, sys.maxint, sys.maxint
        delt = None
        if i > 0 and j > 0:
            delt = 0 if x[i-1] == y[j-1] else 1
            diag = D[i-1, j-1] + delt
        if i > 0:
            vert = D[i-1, j] + 1
        if j > 0:
            horz = D[i, j-1] + 1
        if diag <= vert and diag <= horz:
            # diagonal was best
            xscript.append('R' if delt == 1 else 'M')
            i -= 1; j -= 1
        elif vert <= horz:
            # vertical was best; this is an insertion in x w/r/t y
            xscript.append('I')
            i -= 1
        else:
            # horizontal was best
            xscript.append('D')
            j -= 1
            # j = offset of the first (leftmost) character of t involved in the
            # alignment
    return j, (''.join(xscript))[::-1] # reverse and string-ize

def kEditDp(p, t):
    ''' Find and return the alignment of p to a substring of t with the
        fewest edits.  We return the edit distance, the offset of the
        substring aligned to, and the edit transcript.  If multiple
        alignments tie for best, we report the leftmost. '''
    D = numpy.zeros((len(p)+1, len(t)+1), dtype=int)
    # Note: First row gets zeros.  First column initialized as usual.
    D[1:, 0] = range(1, len(p)+1)
    for i in xrange(1, len(p)+1):
        for j in xrange(1, len(t)+1):
            delt = 1 if p[i-1] != t[j-1] else 0
            D[i, j] = min(D[i-1, j-1] + delt, D[i-1, j] + 1, D[i, j-1] + 1)
            # Find minimum edit distance in last row
    mnJ, mn = None, len(p) + len(t)
    for j in xrange(0, len(t)+1):
        if D[len(p), j] < mn:
            mnJ, mn = j, D[len(p), j]
    # Backtrace; note: stops as soon as it gets to first row
    off, xcript = trace(D, p, t[:mnJ])
    # Return edit distance, offset into T, edit transcript
    return mn, off, xcript, D

p,t = sequenceread, sequenceref
mn, off, xscript, D = kEditDp(p, t)

#find locations of all mismatches, insertions, deletions
indices_R = [i for i, x in enumerate(xscript) if x == "R"]
indices_I = [i for i, x in enumerate(xscript) if x == "I"]
indices_D = [i for i, x in enumerate(xscript) if x == "D"]

indices_all = indices_R + indices_I + indices_D

print len(indices_all)
