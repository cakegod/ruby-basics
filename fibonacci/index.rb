# frozen_string_literal: true

def fibs(number) = 3.upto(number) { |_| [0, 1, 1].tap { |f| f << f[-1] + f[-2] } }

def fibs_rec(number) = number == 2 ? [0, 1, 1] : fibs_rec(number - 1).tap { |f| f << f[-1] + f[-2] }

p fibs(10)
p fibs_rec(10)

