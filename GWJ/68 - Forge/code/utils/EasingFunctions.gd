# 
#  Easing Functions for GODOT ENGINE 4 in GDScript
# 
#  Created by Javier Garrido Galdón
#  
#  The MIT License (MIT)
#  
#  Copyright (c) 2023
#  
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#  
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
#  
#  
#  TERMS OF USE - EASING EQUATIONS
#  Open source under the BSD License.
#  Copyright (c)2001 Robert Penner
#  All rights reserved.
#  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#  Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
#  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
#  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# 
#  ============= Description =============
# 
#  Below is an example of how to use the easing functions in the file. 
#  
#  var value = EasingFunctions.linear(0, 10, 0.67)
#  
# 

class_name EasingFunctions

# We need Float Epsilon to some calculations
const FLOAT_EPSILON = 0.00001

## Easing Linear function
static func linear(start: float, end: float, value: float) -> float:
	return lerp(start, end, value)

## Easing Spring function
static func spring(start: float, end: float, value: float) -> float:
	value = clampf(value, 0, 1)
	value = (sin(value * PI * (0.2 + 2.5 * value * value * value)) * pow(1 - value, 2.2) + value) * (1 + (1.2 * (1 - value)))
	return start + (end - start) * value

## Easing Ease In Quad function
static func ease_in_quad(start: float, end: float, value: float) -> float:
	end -= start
	return end * value * value + start

## Easing Ease Out Quad function
static func ease_out_quad(start: float, end: float, value: float) -> float:
	end -= start
	return -end * value * (value - 2) + start

## Easing Ease In Out Quad function
static func ease_in_out_quad(start: float, end: float, value: float) -> float:
	value /= 0.5
	end -= start
	
	if value < 1:
		return end * 0.5 * value * value + start
		
	value -= 1
	return -end * 0.5 * (value * (value - 2) - 1) + start

## Easing Ease In Cubic function
static func ease_in_cubic(start: float, end: float, value: float) -> float:
	end -= start
	return end * value * value * value + start

## Easing Ease Out Cubic function
static func ease_out_cubic(start: float, end: float, value: float) -> float:
	value -= 1
	end -= start
	return end * (value * value * value + 1) + start

## Easing Ease In Out Cubic function
static func ease_in_out_cubic(start: float, end: float, value: float) -> float:
	value /= 0.5
	end -= start
	
	if value < 1:
		return end * 0.5 * value * value * value + start
		
	value -= 2
	return end * 0.5 * (value * value * value + 2) + start

## Easing Ease In Quart function
static func ease_in_quart(start: float, end: float, value: float) -> float:
	end -= start
	return end * value * value * value * value + start

## Easing Ease Out Quart function
static func ease_out_quart(start: float, end: float, value: float) -> float:
	value -= 1
	end -= start
	return -end * (value * value * value * value - 1) + start

## Easing Ease In Out Quart function
static func ease_in_out_quart(start: float, end: float, value: float) -> float:
	value /= 0.5
	end -= start
	
	if value < 1:
		return end * 0.5 * value * value * value * value + start
		
	value -= 2
	return -end * 0.5 * (value * value * value * value - 2) + start

## Easing Ease In Quint function
static func ease_in_quint(start: float, end: float, value: float) -> float:
	end -= start
	return end * value * value * value * value * value + start

## Easing Ease Out Quint function
static func ease_out_quint(start: float, end: float, value: float) -> float:
	value -= 1
	end -= start
	return end * (value * value * value * value * value + 1) + start

## Easing Ease In Out Quint function
static func ease_in_out_quint(start: float, end: float, value: float) -> float:
	value /= 0.5
	end -= start
	
	if value < 1:
		return end * 0.5 * value * value * value * value * value + start
		
	value -= 2
	return end * 0.5 * (value * value * value * value * value + 2) + start

## Easing Ease In Sine function
static func ease_in_sine(start: float, end: float, value: float) -> float:
	end -= start
	return -end * cos(value * (PI * 0.5)) + end + start

## Easing Ease Out Sine function
static func ease_out_sine(start: float, end: float, value: float) -> float:
	end -= start
	return end * sin(value * (PI * 0.5)) + start

## Easing Ease In Out Sine function
static func ease_in_out_sine(start: float, end: float, value: float) -> float:
	end -= start
	return -end * 0.5 * (cos(PI * value) - 1) + start

## Easing Ease In Expo function
static func ease_in_expo(start: float, end: float, value: float) -> float:
	end -= start
	return end * pow(2, 10 * (value - 1)) + start

## Easing Ease Out Expo function
static func ease_out_expo(start: float, end: float, value: float) -> float:
	end -= start
	return end * (-pow(2, -10 * value) + 1) + start

## Easing Ease In Out Expo function
static func ease_in_out_expo(start: float, end: float, value: float) -> float:
	value /= 0.5
	end -= start
	
	if value < 1:
		return end * 0.5 * pow(2, 10 * (value - 1)) + start
		
	value -= 1
	return end * 0.5 * (-pow(2, -10 * value) + 2) + start

## Easing Ease In Circ function
static func ease_in_circ(start: float, end: float, value: float) -> float:
	end -= start
	return -end * (sqrt(1 - value * value) - 1) + start

## Easing Ease Out Circ function
static func ease_out_circ(start: float, end: float, value: float) -> float:
	value -= 1
	end -= start
	return end * sqrt(1 - value * value) + start

## Easing Ease In Out Circ function
static func ease_in_out_circ(start: float, end: float, value: float) -> float:
	value /= 0.5
	end -= start
	
	if value < 1:
		return -end * 0.5 * (sqrt(1 - value * value) - 1) + start
		
	value -= 2
	return end * 0.5 * (sqrt(1 - value * value) + 1) + start

## Easing Ease In Bounce function
static func ease_in_bounce(start: float, end: float, value: float) -> float:
	end -= start
	const d = 1
	return end - ease_out_bounce(0, end, d - value) + start

## Easing Ease Out Bounce function
static func ease_out_bounce(start: float, end: float, value: float) -> float:
	value /= 1
	end -= start
	
	if value < (1 / 2.75):
		return end * (7.5625 * value * value) + start
		
	if value < (2 / 2.75):
		value -= (1.5 / 2.75)
		return end * (7.5625 * (value) * value + 0.75) + start
		
	if value < (2.5 / 2.75):
		value -= (2.25 / 2.75)
		return end * (7.5625 * (value) * value + 0.9375) + start
		
	value -= (2.625 / 2.75)
	return end * (7.5625 * (value) * value + 0.984375) + start

## Easing Ease In Out Bounce function
static func ease_in_out_bounce(start: float, end: float, value: float) -> float:
	end -= start
	const d = 1
	
	if value < d * 0.5:
		return ease_in_bounce(0, end, value * 2) * 0.5 + start
		
	return ease_out_bounce(0, end, value * 2 - d) * 0.5 + end * 0.5 + start

## Easing Ease In Back function
static func ease_in_back(start: float, end: float, value: float) -> float:
	end -= start
	value /= 1
	const s = 1.70158
	return end * (value) * value * ((s + 1) * value - s) + start

## Easing Ease Out Back function
static func ease_out_back(start: float, end: float, value: float) -> float:
	const s = 1.70158
	end -= start
	value -= 1
	return end * ((value) * value * ((s + 1) * value + s) + 1) + start

## Easing Ease In Out Back function
static func ease_in_out_back(start: float, end: float, value: float) -> float:
	var s = 1.70158
	end -= start
	value /= 0.5
	
	if (value) < 1:
		s *= 1.525
		return end * 0.5 * (value * value * (((s) + 1) * value - s)) + start
		
	value -= 2
	s *= 1.525
	return end * 0.5 * ((value) * value * (((s) + 1) * value + s) + 2) + start

## Easing Ease In Elastic function
static func ease_in_elastic(start: float, end: float, value: float) -> float:
	end -= start
	const d = 1
	const p = d * 0.3
	var s
	var a = 0
	
	if absf(value) < FLOAT_EPSILON:
		return start
		
	value /= d
	if absf(value - 1) < FLOAT_EPSILON:
		return start + end
		
	if absf(a) < FLOAT_EPSILON || a < absf(end):
		a = end
		s = p / 4
	else:
		s = p / (2 * PI) * asin(end / a)
		
	value -= 1
	return -(a * pow(2, 10 * value) * sin((value * d - s) * (2 * PI) / p)) + start

## Easing Ease Out Elastic function
static func ease_out_elastic(start: float, end: float, value: float) -> float:
	end -= start
	const d = 1
	const p = d * 0.3
	var s
	var a = 0
	
	if abs(value) < FLOAT_EPSILON:
		return start
		
	value /= d
	if abs((value - 1) < FLOAT_EPSILON):
		return start + end
		
	if abs(a) < FLOAT_EPSILON || a < abs(end):
		a = end
		s = p * 0.25
	else:
		s = p / (2 * PI) * asin(end / a)
		
	return (a * pow(2, -10 * value) * sin((value * d - s) * (2 * PI) / p) + end + start)

## Easing Ease In Out Elastic function
static func ease_in_out_elastic(start: float, end: float, value: float) -> float:
	end -= start
	const d = 1
	const p = d * 0.3
	var s
	var a = 0
	
	if abs(value) < FLOAT_EPSILON:
		return start;
		
	value /= d
	if (abs(value * 0.5) - 2) < FLOAT_EPSILON:
		return start + end
		
	if abs(a) < FLOAT_EPSILON || a < abs(end):
		a = end
		s = p / 4
	else:
		s = p / (2 * PI) * asin(end / a)
		
	if value < 1:
		value -= 1
		return -0.5 * (a * pow(2, 10 * value) * sin((value * d - s) * (2 * PI) / p)) + start
		
	value -= 1
	return a * pow(2, -10 * value) * sin((value * d - s) * (2 * PI) / p) * 0.5 + end + start
